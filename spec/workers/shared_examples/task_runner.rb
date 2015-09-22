shared_examples 'task runner worker' do
  it 'should run all tasks in valid order' do
    pattern =
      'component_1_tasks for leaf_component_1 dir: ' \
      '/[^ ]+/leaf_component_1_destination\n' \
      'component_1_tasks for leaf_component_2 dir: ' \
      '/[^ ]+/component_1_destination/leaf_component_2_destination\n' \
      'component_2_task\n' \
      'leaf_component_3_dir /[^ ]+/leaf_component_3_destination\n' \
      'base_component_second_tasks for component_1\n' \
      'base_component_second_tasks for component_2\n' \
      'base_component_first_task'

    expect { subject.call }.to output(/#{pattern}/).to_stderr
  end
end
