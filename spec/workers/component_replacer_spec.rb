# GitCompound
#
module GitCompound
  describe Worker::ComponentReplacer do
    let(:component_1) { create_component_1 }
    let(:component_2) { create_component_2 }

    let(:old_component) do
      component_1_dir = component_1.origin
      Component.new(:component_old) do
        branch 'master'
        source component_1_dir
        destination '/component_dir_test'
      end
    end

    let(:new_component) do
      component_2_dir = component_2.origin
      Component.new(:component_new) do
        version '0.1'
        source component_2_dir
        destination '/component_dir_test'
      end
    end

    before { old_component.build! }

    subject do
      -> { described_class.new(Lock.new).visit_component(new_component) }
    end

    it 'prints information about component being replaced' do
      expect { subject.call }
        .to output(/^Replacing:\s+`component_new` component, version: 0\.1.*$/)
        .to_stdout
    end

    it 'checkouts valid ref in new component' do
      subject.call
      ref = git("#{@dir}/component_dir_test") { git_current_ref }
      expect(ref).to eq 'v0.1'
    end

    it 'sets new origin remote in new component' do
      subject.call
      origin = git("#{@dir}/component_dir_test") { git_remotes.first['origin'] }
      expect(origin).to match(/#{component_2.origin}/)
    end
  end
end
