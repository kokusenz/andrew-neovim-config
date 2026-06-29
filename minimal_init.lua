local config = vim.fn.stdpath('config')
vim.opt.rtp:remove(config)
vim.opt.rtp:remove(config .. '/after')
package.path = config .. '/lua/?.lua;' .. config .. '/lua/?/init.lua;' .. package.path
require('conveniences')
require('preferences')
require('statusline')
require('searching')
