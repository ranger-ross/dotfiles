-- GitHub Commit Viewer
-- Opens the GitHub page for the commit of the current line

local M = {}

-- Function to get the git remote URL
local function get_remote_url()
  local handle = io.popen 'git config --get remote.origin.url 2>/dev/null'
  if not handle then
    return nil
  end
  local url = handle:read '*l'
  handle:close()
  return url
end

-- Function to parse GitHub URL from git remote
local function parse_github_url(remote_url)
  if not remote_url then
    return nil
  end

  -- Handle HTTPS URLs: https://github.com/user/repo.git
  local user, repo = remote_url:match 'https://github%.com/([^/]+)/([^/%.]+)'

  -- Handle SSH URLs: git@github.com:user/repo.git
  if not user then
    user, repo = remote_url:match 'git@github%.com:([^/]+)/([^/%.]+)'
  end

  if user and repo then
    -- Remove .git suffix if present
    repo = repo:gsub('%.git$', '')
    return string.format('https://github.com/%s/%s', user, repo)
  end

  return nil
end

-- Function to get commit hash for current line
local function get_commit_hash(file, line)
  local cmd = string.format('git blame -L %d,%d --porcelain "%s" 2>/dev/null', line, line, file)
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end

  local output = handle:read '*l'
  handle:close()

  if not output then
    return nil
  end

  -- First line of porcelain format is the commit hash
  local hash = output:match '^(%x+)'

  -- Check if this is an uncommitted change
  if hash and hash:match '^0+$' then
    return nil, 'Line not yet committed'
  end

  return hash
end

-- Function to open URL in browser
local function open_url(url)
  local open_cmd
  if vim.fn.has 'mac' == 1 then
    open_cmd = 'open'
  elseif vim.fn.has 'unix' == 1 then
    open_cmd = 'xdg-open'
  elseif vim.fn.has 'win32' == 1 then
    open_cmd = 'start'
  else
    vim.notify('Unsupported operating system', vim.log.levels.ERROR)
    return false
  end

  local cmd = string.format('%s "%s" >/dev/null 2>&1 &', open_cmd, url)
  os.execute(cmd)
  return true
end

-- Main function to open GitHub commit
function M.open_commit()
  -- Get current file and line
  local file = vim.fn.expand '%:p'
  local line = vim.fn.line '.'

  -- Check if we're in a file
  if file == '' then
    vim.notify('No file open', vim.log.levels.WARN)
    return
  end

  -- Make path relative to git root
  local handle = io.popen 'git rev-parse --show-toplevel 2>/dev/null'
  if not handle then
    vim.notify('Not in a git repository', vim.log.levels.ERROR)
    return
  end

  local git_root = handle:read '*l'
  handle:close()

  if not git_root or git_root == '' then
    vim.notify('Not in a git repository', vim.log.levels.ERROR)
    return
  end

  -- Get relative path
  local relative_file = file:gsub('^' .. git_root .. '/', '')

  -- Get commit hash
  local hash, err = get_commit_hash(relative_file, line)
  if not hash then
    vim.notify(err or 'Could not get commit hash', vim.log.levels.ERROR)
    return
  end

  -- Get GitHub URL
  local remote_url = get_remote_url()
  local github_url = parse_github_url(remote_url)

  if not github_url then
    vim.notify('Could not parse GitHub URL from git remote', vim.log.levels.ERROR)
    return
  end

  -- Construct commit URL
  local commit_url = string.format('%s/commit/%s', github_url, hash)

  -- Open in browser
  vim.notify(string.format('Opening commit %s...', hash:sub(1, 7)), vim.log.levels.INFO)
  open_url(commit_url)
end

return M
