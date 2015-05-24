# GitCompound
module GitCompound
  describe Component do
    before do
      Dir.mkdir('/component1')
      File.open('/component1/Compoundfile', 'w') do |f|
        f.puts 'name "test component 1"'
      end
      @component = Component.new(:test_component) do
        version '~>1.1'
        source '/component1'
        destination 'some destination'
      end
    end

    it 'should set version parameter' do
      expect(@component.version).to eq '~>1.1'
    end

    it 'should set source parameter' do
      expect(@component.source).to eq '/component1'
    end

    it 'should set destination parameter' do
      expect(@component.destination).to eq 'some destination'
    end

    context 'component manifest is stored in Compoundfile' do
      it do
        manifest = @component.load_manifest
        expect(manifest).to be_instance_of Manifest
      end
    end

    context 'component manifest is stored in .gitcompound file' do
      it do
        Dir.mkdir('/component2')
        File.open('/component2/.gitcompound', 'w') do |f|
          f.puts 'name "test component 2"'
        end
        component2 = Component.new(:test_component2) do
          version '~>1.1'
          source '/component2'
          destination 'some destination'
        end
        expect(component2.load_manifest).to be_instance_of Manifest
      end
    end
  end
end
