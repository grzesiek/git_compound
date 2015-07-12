# GitCompound
#
module GitCompound
  describe Worker::ComponentReplacer do
    before do
      git_create_component_1
      git_create_component_2

      component_1_dir = @component_1_dir
      component_2_dir = @component_2_dir

      component_1 = Component.new(:component_first) do
        branch 'master'
        source component_1_dir
        destination '/component_dir_test'
      end
      component_1.build

      @component_2 = Component.new(:component_second) do
        version '0.1'
        source component_2_dir
        destination '/component_dir_test'
      end

      @lock_old = Lock.new
      @lock_old.lock_component(component_1)

      @lock_new = Lock.new(Dir::Tmpname.make_tmpname('git', 'compound'))
    end

    subject do
      -> { described_class.new(@lock_old, @lock_new).visit_component(@component_2) }
    end

    it 'prints information about component being replaced' do
      expect { subject.call }
        .to output(/^Replacing:\s+`component_second` component, gem version: 0\.1$/)
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
      expect(origin).to match(/#{@component_2_dir}/)
    end
  end
end
