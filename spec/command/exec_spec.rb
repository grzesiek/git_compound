describe 'gitcompound executable' do
  subject do
    ->(*args) { `#{@gem_dir}/exe/gitcompound #{args.join(' ')} 2>&1` }
  end

  it 'prints help message' do
    expect(subject.call('help')).to match(/Usage/)
  end

  it 'prints verbose information if verbose parameter is passed' do
    expect(subject.call('help', '--verbose')).to match(/Running command `help`/)
  end

  it 'prints error when manifest file is not found' do
    expect(subject.call('show', 'Manifest'))
      .to match(/Error: Manifest `Manifest` not found !/)
  end

  it 'detects manfiest parameter if order is invalid' do
    expect(subject.call('build', '--allow-nested-subtask', 'Manifest'))
      .to match(/Error: Manifest `Manifest` not found !/)
  end

  it 'enables colors by default' do
    expect(subject.call('help')).to include "\e[1;33;49mGitCompound"
  end

  it 'disables colors if disable-colors parameter is passed' do
    expect(subject.call('help', '--disable-colors'))
      .to_not include "\e[1;33;49mGitCompound"
  end
end
