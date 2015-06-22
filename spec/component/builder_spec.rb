
# GitCompound
#
module GitCompound
  describe Component do
    before do
      git_create_component_2

      component_dir = @component_2_dir
      @component = Component.new(:component_2) do
        version '1.1'
        source component_dir
        destination '/component_2_destination'
      end

      @destination = "#{@dir}/#{@component.destination.absolute_path}"
      @component.build
    end

    pending 'should clone source to destination' do
      expect(File.directory?("#{@destination}/.git}")).to be true
      expect(File.exist?("#{@destination}/.Compoundfile}")).to be true
    end

    pending 'should checkout valid ref' do
      manifest_lines_count = 0
      File.open("#{@destination}/.Compoundfile}") do
        |f| manifest_lines_count = f.read.count("\n")
      end
      expect(manifest_lines_count).to eq 7
    end
  end
end
