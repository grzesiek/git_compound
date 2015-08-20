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

  def git_remotes
    `git remote -v`.split("\n").map { |remote| Hash[*remote.split("\t")] }
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
    `git rev-parse HEAD`.strip
  end

  def git_tag(name, message)
    `git tag -a "#{name}" -m "#{message}"`
    `git rev-parse #{name}^{}`.strip
  end

  def git_expose(dir, port)
    cmd = "git daemon --reuseaddr --listen=127.0.0.1 --port=#{port} #{dir}"
    pid = Process.spawn(cmd)
    Process.detach(pid)
    sleep 0.05
    pid
  end

  def git_current_ref
    `git symbolic-ref --short HEAD 2>/dev/null || \
     git describe --tags --exact-match HEAD 2>/dev/null || \
     git rev-parse HEAD 2>/dev/null`.strip
  end

  def git_head_sha
    `git rev-parse HEAD 2>/dev/null`.strip
  end

  def git_commits
    `git log --oneline`.strip
  end

  def git_branch_new(branch_name)
    `git checkout -b #{branch_name} >/dev/null 2>&1`
  end

  def git_branch_push(branch_name)
    `git push -u origin #{branch_name} >/dev/null 2>&1`
  end
end
