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
  end

  def git_tag(name, message)
    `git tag -a "#{name}" -m "#{message}"`
  end

  def git_expose(dir, port)
    cmd = "git daemon --reuseaddr --listen=127.0.0.1 --port=#{port} #{dir}"
    pid = Process.spawn(cmd)
    Process.detach(pid)
    pid
  end
end
