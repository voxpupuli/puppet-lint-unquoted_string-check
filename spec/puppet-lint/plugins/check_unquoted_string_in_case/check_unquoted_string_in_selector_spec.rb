require 'spec_helper'

describe 'unquoted_string_in_selector' do
  let(:msg) { 'expected quoted string in selector' }

  context 'with fix disabled' do
    context 'quoted case' do
      let(:code) do
        <<-EOS
        $rootgroup = $osfamily ? {
          'Solaris'          => 'wheel',
          /(Darwin|FreeBSD)/ => 'wheel',
          default            => 'root',
        }
        EOS
      end

      it 'should not detect any problems' do
        expect(problems).to have(0).problems
      end
    end

    context ':NAME in case' do
      let(:code) do
        <<-EOS
        $rootgroup = $osfamily ? {
          solaris            => 'wheel',
          /(Darwin|FreeBSD)/ => 'wheel',
          default            => 'root',
        }
        EOS
      end

      it 'should create a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(32)
      end
    end

    context ':CLASSREF in case' do
      let(:code) do
        <<-EOS
        $rootgroup = $osfamily ? {
          Solaris            => 'wheel',
          /(Darwin|FreeBSD)/ => 'wheel',
          default            => 'root',
        }
        EOS
      end

      it 'should create a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(32)
      end
    end
  end
end
