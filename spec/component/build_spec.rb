
# GitCompound
#
module GitCompound
  describe Component do
    before do
      git_create_component_2

      component_dir = @component_2_dir
      @component = Component.new(:component_2) do
        version '0.1'
        source component_dir
        destination '/component_2_destination'
      end

      @destination = "#{@dir}/#{@component.destination_path}"
      @component.build
    end

    it 'should clone source to destination' do
      expect(File.directory?(@destination + '.git')).to be true
      expect(File.exist?(@destination + 'Compoundfile')).to be true
    end

    it 'should checkout valid ref' do
      expect(File.read(@destination + 'Compoundfile'))
        .to eq "name :component_2_test\n"
    end
  end
end
