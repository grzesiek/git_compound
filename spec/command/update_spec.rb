require 'workers/shared_context/out_of_date_environment'
require 'workers/shared_examples/component_updater'
require 'workers/shared_examples/local_changes_guard'
require 'workers/shared_examples/task_runner'

describe GitCompound do
  describe '#update' do
    include_context 'out of date environment'

    subject do
      -> { GitCompound.update("#{@base_component_dir}/Compoundfile") }
    end

    it_behaves_like 'component updater worker'
    it_behaves_like 'local changes guard worker'

    it 'builds new components' do
      expect { subject.call }
        .to output(/^Building:   `new_component` component, gem version: 1.0$/)
        .to_stdout
    end

    it 'protectes local changes' do
      Dir.chdir('component_1') { FileUtils.touch('untracked') }
      expect{ subject.call }.to raise_error(GitCompound::LocalChangesError,
                                            /untracked files/)
    end

    pending 'replaces components that has been replaced in manifest' do
      fail 'TODO'
    end

    pending 'removes dormant components' do
      fail 'TODO'
    end

    pending 'updates lockfile' do
      fail 'TODO'
    end
  end
end
