# GitCompound
#
module GitCompound
  shared_examples 'local changes guard worker' do
    before do
      @test_dir = @component_1_dst.sub(%r{^/}, '')
    end

    context 'repository is clean' do
      it 'should not raise error if repository is clean' do
        expect { subject.call }.to_not raise_error
      end
    end

    context 'repository has uncommited changes' do
      before do
        Dir.chdir(@test_dir) do
          File.open('.gitcompound', 'w') { |f| f.puts 'tracked file editted' }
        end
      end

      it 'should raise error if local changes are detected' do
        expect { subject.call }.to raise_error(LocalChangesError,
                                               /contains uncommited changes/)
      end
    end

    context 'repository has untracked files' do
      it 'should raise error if untracked file is detected' do
        Dir.chdir(@test_dir) do
          File.open('untracked_file_1', 'w') { |f| f.puts 'added untracked file' }
          Dir.mkdir('untracked_dir')
          File.open('untracked_dir/untracked_file_2', 'w') { |f| f.puts 'untracked' }
        end

        expect { subject.call }.to raise_error(LocalChangesError,
                                               /contains untracked files/)
      end

      it 'should not raise error if untracked files belong to locked components' do
        %w(untracked_component_1 untracked_component_2).each do |dst|
          component_dir = @component_1_dir
          destination_dir = "#{@component_1_dst}#{dst}"
          tmp_component = Component.new(:tmp) do
            branch 'master'
            source component_dir
            destination destination_dir
          end
          @lock.lock_component(tmp_component)
          tmp_component.build!
        end
        @lock.write

        expect { subject.call }.to_not raise_error
      end
    end
  end
end
