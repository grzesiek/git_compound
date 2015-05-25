# GitCompound
module GitCompound
  describe Component do
    before do
      Dir.mkdir('/component1')
      File.open('/component1/Compoundfile', 'w') do |f|
        f.puts 'name "test component 1"'
      end
      @component_1 = Component.new(:test_component_1) do
        version '~>1.1'
        source '/component1'
        destination 'some destination'
      end
    end

    it 'should set version parameter' do
      expect(@component_1.version).to eq '~>1.1'
    end

    it 'should set source parameter' do
      expect(@component_1.source).to eq '/component1'
    end

    it 'should set destination parameter' do
      expect(@component_1.destination).to eq 'some destination'
    end

    context 'component manifest is stored in Compoundfile' do
      it do
        manifest = @component_1.load_manifest
        expect(manifest).to be_instance_of Manifest
      end
    end

    context 'component manifest is stored in .gitcompound file' do
      it do
        Dir.mkdir('/component2')
        File.open('/component2/.gitcompound', 'w') do |f|
          f.puts 'name "test component 2"'
        end
        component_2 = Component.new(:test_component_2) do
          version '~>1.1'
          source '/component2'
          destination 'some destination'
        end
        expect(component_2.load_manifest).to be_instance_of Manifest
      end
    end

    context 'manifest file is not found' do
      before do
        @component_3 = Component.new(:test_component_3) do
          version '~>1.1'
          source '/component3'
          destination 'some destination'
        end
      end

      it 'should return nil if manifest is not found' do
        expect(@component_3.load_manifest).to eq nil
      end
    end
  end
end
