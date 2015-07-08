# GitCompound
#
module GitCompound
  shared_examples 'local changes guard worker' do
    context 'repository is clean' do
      it 'should not raise error if repository is clean' do
        expect { subject.call }.to_not raise_error
      end
    end

    context 'repository has uncommited changes' do
      before do
        git(@component_1_dst) do
          File.open('.gitcompound', 'w') { |f| f.puts 'tracked file editted' }
        end
      end

      it 'should raise error if local changes are detected' do
        expect { subject.call }.to raise_error(LocalChangesError,
                                               /contains uncommited changes/)
      end
    end

    context 'repository has untracked files' do
      before do
        git(@component_1_dst) do
          File.open('untracked_file_1', 'w') { |f| f.puts 'added untracked file' }
          Dir.mkdir('untracked_dir')
          File.open('untracked_dir/untracked_file_2', 'w') { |f| f.puts 'untracked' }
        end
      end

      it 'should raise error if untracked file is detected' do
        expect { subject.call }.to raise_error(LocalChangesError,
                                               /contains untracked files/)
      end

      it 'should not raise error if untracked files belong to locked components' do
        %w(untracked_file_1 untracked_dir).each do |dst|
          component_dir = @component_1_dir
          destination_dir = "#{@component_1_dst}#{dst}"
          tmp_component = Component.new(:tmp) do
            branch 'master'
            source component_dir
            destination destination_dir
          end
          @lock.lock_component(tmp_component)
        end

        expect { subject.call }.to_not raise_error
      end
    end
  end
end
