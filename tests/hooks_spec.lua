local State = require("which-key.state")
local Config = require("which-key.config")
local Util = require("which-key.util")

local hooks_called = {}

---Clear the hooks tracking table
local function clear_hooks()
  hooks_called = {}
end

---Create a test hook that records its context
---@param hook_type string
---@param return_value? any
---@return fun(ctx: any): nil
local function create_test_hook(hook_type, return_value)
  return function(ctx)
    table.insert(hooks_called, {
      type = hook_type,
      ctx = ctx,
      return_value = return_value,
    })
  end
end

---Wait for hooks to be called (they run via vim.schedule)
---@param timeout? number
---@return boolean
local function wait_for_hooks(timeout)
  timeout = timeout or 100
  local start = vim.loop.hrtime() / 1e6
  while vim.loop.hrtime() / 1e6 - start < timeout do
    vim.cmd("sleep 10m")
    if #hooks_called > 0 then
      return true
    end
  end
  return #hooks_called > 0
end

before_each(function()
  require("helpers").reset()
  clear_hooks()
  Config.options.hooks = {}
end)

describe("hooks", function()
  describe("configuration", function()
    it("should have empty hooks by default", function()
      assert.is_table(Config.hooks)
      assert.is_nil(Config.hooks.start)
      assert.is_nil(Config.hooks.stop)
      assert.is_nil(Config.hooks.execute)
      assert.is_nil(Config.hooks.check)
    end)

    it("should accept a single hook function", function()
      local hook_called = false
      Config.options.hooks = {
        start = function(ctx)
          hook_called = true
          assert.equals("start", ctx.type)
          assert.is_table(ctx.state)
        end,
      }

      local mock_state = {
        mode = { mode = "n" },
        node = { keys = "", path = {} },
        started = vim.loop.hrtime() / 1e6,
        show = true,
      }

      State._run_hooks("start", { type = "start", state = mock_state })
      wait_for_hooks()
      assert.is_true(hook_called)
    end)

    it("should accept an array of hook functions", function()
      local call_count = 0
      Config.options.hooks = {
        stop = {
          function(ctx)
            call_count = call_count + 1
            assert.equals("stop", ctx.type)
          end,
          function(ctx)
            call_count = call_count + 1
            assert.equals("stop", ctx.type)
          end,
        },
      }

      local mock_state = {
        mode = { mode = "n" },
        node = { keys = "", path = {} },
        started = vim.loop.hrtime() / 1e6,
        show = true,
      }

      State._run_hooks("stop", { type = "stop", state = mock_state })
      wait_for_hooks(200)
      assert.equals(2, call_count)
    end)
  end)

  describe("_run_hooks helper", function()
    it("should execute hooks asynchronously via vim.schedule", function()
      local hook_immediate = false
      Config.options.hooks = {
        start = function(ctx)
          hook_immediate = true
        end,
      }

      local mock_state = {
        mode = { mode = "n" },
        node = { keys = "", path = {} },
        started = vim.loop.hrtime() / 1e6,
        show = true,
      }

      State._run_hooks("start", { type = "start", state = mock_state })
      assert.is_false(hook_immediate)

      wait_for_hooks()
      assert.is_true(hook_immediate)
    end)

    it("should handle hook errors gracefully with pcall", function()
      local error_logged = false
      local original_warn = Util.warn
      Util.warn = function(msg)
        if type(msg) == "string" and msg:find("Hook error") then
          error_logged = true
        end
      end

      Config.options.hooks = {
        execute = function(ctx)
          error("Intentional test error")
        end,
      }

      State._run_hooks("execute", { type = "execute" })
      wait_for_hooks()

      assert.is_true(error_logged)
      Util.warn = original_warn
    end)

    it("should not throw error for missing hooks", function()
      assert.has_no.errors(function()
        State._run_hooks("nonexistent", { type = "nonexistent" })
      end)
    end)
  end)

  describe("hook types", function()
    it("should support start hook", function()
      Config.options.hooks = {
        start = create_test_hook("start"),
      }

      local mock_state = {
        mode = { mode = "n" },
        node = { keys = "", path = {} },
        started = vim.loop.hrtime() / 1e6,
        show = true,
      }

      State._run_hooks("start", { type = "start", state = mock_state })
      wait_for_hooks()

      assert.equals(1, #hooks_called)
      assert.equals("start", hooks_called[1].type)
      assert.is_table(hooks_called[1].ctx.state)
    end)

    it("should support stop hook", function()
      Config.options.hooks = {
        stop = create_test_hook("stop"),
      }

      local mock_state = {
        mode = { mode = "n" },
        node = { keys = "", path = {} },
        started = vim.loop.hrtime() / 1e6,
        show = true,
      }

      State._run_hooks("stop", { type = "stop", state = mock_state })
      wait_for_hooks()

      assert.equals(1, #hooks_called)
      assert.equals("stop", hooks_called[1].type)
      assert.is_table(hooks_called[1].ctx.state)
    end)

    it("should support execute hook with key and node", function()
      Config.options.hooks = {
        execute = create_test_hook("execute"),
      }

      local mock_node = { keys = "test", desc = "test desc" }
      local mock_state = {
        mode = { mode = "n" },
        node = mock_node,
        started = vim.loop.hrtime() / 1e6,
        show = true,
      }

      State._run_hooks("execute", {
        type = "execute",
        state = mock_state,
        key = "<leader>",
        node = mock_node,
      })
      wait_for_hooks()

      assert.equals(1, #hooks_called)
      assert.equals("execute", hooks_called[1].type)
      assert.is_table(hooks_called[1].ctx.state)
      assert.equals("<leader>", hooks_called[1].ctx.key)
      assert.is_table(hooks_called[1].ctx.node)
    end)

    it("should support check hook with key", function()
      Config.options.hooks = {
        check = create_test_hook("check"),
      }

      local mock_state = {
        mode = { mode = "n" },
        node = { keys = "", path = {} },
        started = vim.loop.hrtime() / 1e6,
        show = true,
      }

      State._run_hooks("check", {
        type = "check",
        state = mock_state,
        key = "a",
      })
      wait_for_hooks()

      assert.equals(1, #hooks_called)
      assert.equals("check", hooks_called[1].type)
      assert.is_table(hooks_called[1].ctx.state)
      assert.equals("a", hooks_called[1].ctx.key)
    end)
  end)

  describe("hook context", function()
    it("should provide correct context for start hook", function()
      local received_ctx = nil
      Config.options.hooks = {
        start = function(ctx)
          received_ctx = ctx
        end,
      }

      local mock_state = {
        mode = { mode = "n", tree = { root = {} } },
        node = { keys = "<leader>f", path = { "<leader>", "f" } },
        started = vim.loop.hrtime() / 1e6,
        show = true,
        filter = { keys = "<leader>f" },
      }

      State._run_hooks("start", { type = "start", state = mock_state })
      wait_for_hooks()

      assert.is_table(received_ctx)
      assert.equals("start", received_ctx.type)
      assert.is_table(received_ctx.state)
      assert.equals("n", received_ctx.state.mode.mode)
      assert.equals("<leader>f", received_ctx.state.node.keys)
    end)

    it("should provide correct context for execute hook", function()
      local received_ctx = nil
      Config.options.hooks = {
        execute = function(ctx)
          received_ctx = ctx
        end,
      }

      local mock_node = {
        keys = "<leader>ff",
        desc = "Find file",
        action = function() end,
      }
      local mock_state = {
        mode = { mode = "n" },
        node = mock_node,
        started = vim.loop.hrtime() / 1e6,
        show = true,
      }

      State._run_hooks("execute", {
        type = "execute",
        state = mock_state,
        key = "f",
        node = mock_node,
      })
      wait_for_hooks()

      assert.is_table(received_ctx)
      assert.equals("execute", received_ctx.type)
      assert.equals("f", received_ctx.key)
      assert.equals("<leader>ff", received_ctx.node.keys)
    end)
  end)

  describe("hook execution order", function()
    it("should execute multiple hooks in order", function()
      local order = {}
      Config.options.hooks = {
        start = {
          function(ctx)
            table.insert(order, 1)
          end,
          function(ctx)
            table.insert(order, 2)
          end,
          function(ctx)
            table.insert(order, 3)
          end,
        },
      }

      State._run_hooks("start", { type = "start", state = {} })
      wait_for_hooks(200)

      assert.same({ 1, 2, 3 }, order)
    end)
  end)

  describe("integration", function()
    it("_run_hooks is available for internal use", function()
      assert.is_function(State._run_hooks)
    end)
  end)
end)
