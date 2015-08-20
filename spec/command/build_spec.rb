require 'workers/shared_examples/component_builder'
require 'workers/shared_examples/task_runner'

describe GitCompound do
  describe '#build' do
    context 'lock file does not exist' do
      before { git_build_test_environment! }
      let(:components) { git_test_env_components }

      context 'safe build' do
        subject do
          -> { GitCompound.build("#{@base_component_dir}/Compoundfile") }
        end

        it_behaves_like 'component builder worker'

        it 'executes only root manifest tasks' do
          expect { subject.call }
            .to output(
              "base_component_second_tasks for component_1\n"        \
              "base_component_second_tasks for component_2\n"        \
              "base_component_first_task\n"
            ).to_stderr
        end
      end

      context 'unsafe nested subtasks builder' do
        subject do
          lambda do
            GitCompound.build("#{@base_component_dir}/Compoundfile",
                              allow_nested_subtasks: true)
          end
        end

        it_behaves_like 'component builder worker'
        it_behaves_like 'task runner worker'
      end

      it 'creates valid lockfile' do
        GitCompound.build("#{@base_component_dir}/Compoundfile")
        lock = File.read(GitCompound::Lock::FILENAME)

        expect(GitCompound::Lock.exist?).to be true
        expect(lock).to match(/^:manifest: .{32}/)
        expect(lock).to match(/^:components:/)
        expect(lock).to match(/:name: :component_1/)
        expect(lock).to match(/:name: :component_2/)
        expect(lock).to match(/:name: :leaf_component_1/)
        expect(lock).to match(/:name: :leaf_component_2/)
        expect(lock).to match(/:name: :leaf_component_3/)
      end
    end

    context 'lock file exists' do
      subject do
        -> { GitCompound.build("#{@base_component_dir}/Compoundfile") }
      end

      before do
        git_build_test_environment!
        subject.call
      end

      let(:components) { git_test_env_components }

      it_behaves_like 'component builder worker'

      it 'does not build or update components already installed' do
        expect { subject.call }.to_not output(/Building:\s+|Updating:\s+/).to_stdout
      end
    end
  end
end
