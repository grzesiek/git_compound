# Git Helper module
#
module GitHelper
  def git(path)
    raise unless block_given?
    Dir.chdir(path) do
      yield
    end
  end

  def git_init
    `git init`
    `git config user.name test_user`
    `git config user.email test_email`
  end

  def git_add_file(name, &block)
    File.open(name, 'w') { |f| f.puts block.call }
    `git add #{name}`
  end

  def git_edit_file(name, &block)
    git_add_file(name, &block)
  end

  def git_rm_file(name)
    `git rm #{name}`
  end

  def git_commit(message)
    `git commit -m "#{message}"`
    sha = `git rev-parse HEAD`
    sha.strip
  end

  def git_tag(name, message)
    `git tag -a "#{name}" -m "#{message}"`
    sha = `git rev-parse #{name}`
    sha.strip
  end

  def git_expose(dir, port)
    cmd = "git daemon --reuseaddr --listen=127.0.0.1 --port=#{port} #{dir}"
    pid = Process.spawn(cmd)
    Process.detach(pid)
    sleep 0.05
    pid
  end

  def git_current_ref_matches?(ref)
    current = `git symbolic-ref --short HEAD 2>/dev/null || \
               git describe --tags --exact-match HEAD 2>/dev/null || \
               git rev-parse HEAD 2>/dev/null`
    ref.strip == current.strip
  end

  def git_commits
    `git log --oneline`.strip
  end
end
