require 'workers/shared_examples/component_builder'
require 'workers/shared_examples/task_runner'

describe GitCompound do
  describe '#build' do
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

    context 'unsafe stacked tasks builder' do
      subject do
        lambda do
          GitCompound.build("#{@base_component_dir}/Compoundfile",
                            '--unsafe-stacked-tasks')
        end
      end

      it_behaves_like 'component builder worker'
      it_behaves_like 'task runner worker'
    end
  end
end
