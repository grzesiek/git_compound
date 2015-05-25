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

  def git_rm_file(name)
    `git rm #{name}`
  end

  def git_commit(message)
    `git commit -m "#{message}"`
  end

  def git_tag(name, message)
    `git tag -a "#{name}" -m "#{message}"`
  end
end
