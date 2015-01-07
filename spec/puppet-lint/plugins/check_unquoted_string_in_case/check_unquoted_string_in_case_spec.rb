require 'spec_helper'

describe 'unquoted_string_in_case' do
  let(:msg) { 'expected quoted string in case' }

  context 'with fix disabled' do
    context 'quoted case' do
      let(:code) do
        <<-EOS
        case $osfamily {
          'Solaris': {
            $rootgroup = 'wheel'
          }
          /(Darwin|FreeBSD)/: {
            $rootgroup = 'wheel'
          }
          default: {
            $rootgroup = 'root'
          }
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
        case $osfamily {
          solaris: {
            $rootgroup = 'wheel'
          }
          /(Darwin|FreeBSD)/: {
            $rootgroup = 'wheel'
          }
          default: {
            $rootgroup = 'root'
          }
        }
        EOS
      end

      it 'should create a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(9)
      end
    end

    context ':CLASSREF in case' do
      let(:code) do
        <<-EOS
        case $osfamily {
          Solaris: {
            $rootgroup = 'wheel'
          }
          /(Darwin|FreeBSD)/: {
            $rootgroup = 'wheel'
          }
          default: {
            $rootgroup = 'root'
          }
        }
        EOS
      end

      it 'should create a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(9)
      end
    end
  end
end
