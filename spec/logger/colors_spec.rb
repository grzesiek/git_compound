# GitCompound
#
module GitCompound
  describe Logger::Colors do
    before { GitCompound::Logger.colors = true }
    after { GitCompound::Logger.colors = false }

    context 'use #colorize() method' do
      it 'colorize output foreground' do
        expect('Test'.colorize(color: :black)).to include "\e[0;30;49mTest\e[0m"
        expect('Test'.colorize(color: :blue)).to include "\e[0;34;49mTest\e[0m"

        expect('Test'.colorize(color: :default)).to include "\e[0;39;49mTest\e[0m"
      end

      it 'colorize output background' do
        expect('Test'.colorize(bgcolor: :black)).to include "\e[0;39;40mTest\e[0m"
        expect('Test'.colorize(bgcolor: :blue)).to include "\e[0;39;44mTest\e[0m"

        expect('Test'.colorize(bgcolor: :default)).to include "\e[0;39;49mTest\e[0m"
      end

      it 'set output bold' do
        expect('Test'.colorize(mode: :bold)).to include "\e[1;39;49mTest\e[0m"
      end
    end

    context 'use instance methods (#on_{color}, #{color}, #bold)' do
      it 'colorize output foreground' do
        expect('Test'.black).to include "\e[0;30;49mTest\e[0m"
        expect('Test'.blue).to include "\e[0;34;49mTest\e[0m"
      end

      it 'colorize output background' do
        expect('Test'.on_black).to include "\e[0;39;40mTest\e[0m"
        expect('Test'.on_blue).to include "\e[0;39;44mTest\e[0m"
      end

      it 'set output bold' do
        expect('Test'.bold).to include "\e[1;39;49mTest\e[0m"
      end
    end
  end
end
