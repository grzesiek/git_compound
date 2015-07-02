module GitCompound
  shared_context 'existing lockfile' do
    before do
      git_create_component_2

      File.open(Lock::FILENAME, 'w') do |f|
        f.puts '---'
        f.puts ':manifest: "123123123123"'
        f.puts ':components:'
        f.puts '  - :name: :component_2'
        f.puts "    :sha: #{@component_2_commit_tag_v1_2_sha}"
        f.puts "    :source: #{@component_2_dir}"
        f.puts '    :destination: component_2_test/destination_1/'
        f.puts '  - :name: :component_2'
        f.puts "    :sha: #{@component_2_commit_tag_v1_2_sha}"
        f.puts "    :source: #{@component_2_dir}"
        f.puts '    :destination: component_2_test/destination_2/'
      end

      @lock = Lock.new
    end

    after do
      FileUtils.rm(Lock::FILENAME) if
        Lock.exist?
    end
  end
end
