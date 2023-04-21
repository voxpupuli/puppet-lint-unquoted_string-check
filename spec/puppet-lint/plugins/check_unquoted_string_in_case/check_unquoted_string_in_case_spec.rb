require 'spec_helper'

describe 'unquoted_string_in_case' do
  let(:msg) { 'unquoted string in case' }

  context 'with fix disabled' do
    context 'quoted case' do
      let(:code) do
        <<-EOS
        case $osfamily {
          'Solaris': {
            $rootgroup = 'wheel'
          }
          'RedHat','Debian': {
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

      it 'does not detect any problems' do
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
            foo { 'bar': }
          }
          default: {
            $rootgroup = 'root'
          }
        }
        EOS
      end

      it 'does not detect any problems' do
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

      it 'does not detect any problems' do
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
          redhat,debian: {
            include ::foo
          }
          redhat, debian: {
            Foo { bar => 'baz' }
          }
          'redhat',debian: {
            $rootgroup = wheel
          }
          redhat,'debian': {
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

      it 'creates a warning' do
        expect(problems).to have(7).problems
      end

      it 'creates a warning' do
        expect(problems).to contain_warning(msg).on_line(2).in_column(11)
        expect(problems).to contain_warning(msg).on_line(5).in_column(11)
        expect(problems).to contain_warning(msg).on_line(5).in_column(18)
        expect(problems).to contain_warning(msg).on_line(8).in_column(11)
        expect(problems).to contain_warning(msg).on_line(8).in_column(19)
        expect(problems).to contain_warning(msg).on_line(11).in_column(20)
        expect(problems).to contain_warning(msg).on_line(14).in_column(11)
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

      it 'creates a warning' do
        expect(problems).to contain_warning(msg).on_line(2).in_column(11)
      end
    end

    context 'Puppet Types in case' do
      let(:code) do
        <<-EOS
        case $value {
          Integer: { notice('yes int')}
          Array: { notice('yes array')}
          'Debian': { notice('this is Sparta')}
          default: { notice('something else')}
        }
        EOS
      end

      it 'does not detect any problems' do
        expect(problems).to have(0).problems
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
          'RedHat','Debian': {
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

      it 'does not detect any problems' do
        expect(problems).to have(0).problems
      end

      it 'does not modify the manifest' do
        expect(manifest).to eq(code)
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
            foo { 'bar': }
          }
          default: {
            $rootgroup = 'root'
          }
        }
        EOS
      end

      it 'does not detect any problems' do
        expect(problems).to have(0).problems
      end

      it 'does not modify the manifest' do
        expect(manifest).to eq(code)
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

      it 'does not detect any problems' do
        expect(problems).to have(0).problems
      end

      it 'does not modify the manifest' do
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
          redhat,debian: {
            include ::foo
          }
          redhat, debian: {
            Foo { bar => 'baz' }
          }
          'redhat',debian: {
            $rootgroup = wheel
          }
          redhat,'debian': {
            foo { 'bar': }
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

      it 'onlies detect a single problem' do
        expect(problems).to have(7).problem
      end

      it 'fixes the problem' do
        expect(problems).to contain_fixed(msg).on_line(2).in_column(11)
        expect(problems).to contain_fixed(msg).on_line(5).in_column(11)
        expect(problems).to contain_fixed(msg).on_line(5).in_column(18)
        expect(problems).to contain_fixed(msg).on_line(8).in_column(11)
        expect(problems).to contain_fixed(msg).on_line(8).in_column(19)
        expect(problems).to contain_fixed(msg).on_line(11).in_column(20)
        expect(problems).to contain_fixed(msg).on_line(14).in_column(11)
      end

      it 'quotes the case statement' do
        expect(manifest).to eq(
          <<-EOS,
        case $osfamily {
          'solaris': {
            $rootgroup = 'wheel'
          }
          'redhat','debian': {
            include ::foo
          }
          'redhat', 'debian': {
            Foo { bar => 'baz' }
          }
          'redhat','debian': {
            $rootgroup = wheel
          }
          'redhat','debian': {
            foo { 'bar': }
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

      it 'onlies detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'fixes the problem' do
        expect(problems).to contain_fixed(msg).on_line(2).in_column(11)
      end

      it 'quotes the case statement' do
        expect(manifest).to eq(
          <<-EOS,
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

    context 'Puppet Types in case' do
      let(:code) do
        <<-EOS
        case $value {
          Integer: { notice('yes int')}
          Array: { notice('yes array')}
          'Debian': { notice('this is Sparta')}
          default: { notice('something else')}
        }
        EOS
      end

      it 'does not detect any problems' do
        expect(problems).to have(0).problems
      end

      it 'does not modify the manifest' do
        expect(manifest).to eq(code)
      end
    end
  end
end
