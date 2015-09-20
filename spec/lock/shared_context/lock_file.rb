# GitCompound
#
module GitCompound
  shared_context 'existing lockfile' do
    let!(:component) { create_component_2 }

    before do
      File.open(Lock::FILENAME, 'w') do |f|
        f.puts '---'
        f.puts ':manifest: "123123123123"'
        f.puts ':components:'
        f.puts '  - :name: :component_2'
        f.puts "    :sha: #{component.metadata[:tag_v1_2_sha]}"
        f.puts "    :source: #{component.origin}"
        f.puts '    :destination: component_2_test/destination_1/'
        f.puts '  - :name: :component_2'
        f.puts "    :sha: #{component.metadata[:tag_v1_2_sha]}"
        f.puts "    :source: #{component.origin}"
        f.puts '    :destination: component_2_test/destination_2/'
      end
    end

    after do
      FileUtils.rm(Lock::FILENAME) if
        Lock.exist?
    end
  end
end
