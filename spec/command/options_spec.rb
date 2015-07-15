# GitCompound
#
describe GitCompound::Command::Options do
  before do
    argv = ['--verbose', 'build', 'Compoundfile',
            '--allow-nested-subtasks', '--disable-colors']
    @args = described_class.new(argv)
  end

  it 'parses global options' do
    expect(@args.global_options).to eq [:verbose, :disable_colors]
  end

  it 'parses command options' do
    expect(@args.command_options).to eq ['Compoundfile', :allow_nested_subtasks]
  end

  it 'parses command' do
    expect(@args.command).to eq 'build'
  end

  it 'sets global options' do
    expect(GitCompound::Logger.verbose).to be true
  end
end
