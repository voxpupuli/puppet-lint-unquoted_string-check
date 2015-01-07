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

    context 'quoted case containing :NAME' do
      let(:code) do
        <<-EOS
        case $osfamily {
          'Solaris': {
            include ::foo
          }
          /(Darwin|FreeBSD)/: {
            include bar
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

    context 'quoted case containing :CLASSREF' do
      let(:code) do
        <<-EOS
        case $osfamily {
          'Solaris': {
            Foo {
              bar => 'baz',
            }
          }
          /(Darwin|FreeBSD)/: {
            $rootgroup = 'wheel'
            include bar
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

  context 'with fix enabled' do
    before do
      PuppetLint.configuration.fix = true
    end

    after do
      PuppetLint.configuration.fix = false
    end

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

      it 'should not modify the manifest' do
        expect(manifest).to eq(code)
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

      it 'should only detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the problem' do
        expect(problems).to contain_fixed(msg).on_line(1).in_column(9)
      end

      it 'should quote the case statement' do
        expect(manifest).to eq(
          <<-EOS
        case $osfamily {
          'solaris': {
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
        )
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

      it 'should only detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the problem' do
        expect(problems).to contain_fixed(msg).on_line(1).in_column(9)
      end

      it 'should quote the case statement' do
        expect(manifest).to eq(
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
        )
      end
    end
  end
end
