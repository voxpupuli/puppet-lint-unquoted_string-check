require 'spec_helper'

describe 'unquoted_string_in_selector' do
  let(:msg) { 'unquoted string in selector' }

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
        expect(problems).to contain_warning(msg).on_line(2).in_column(11)
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
        expect(problems).to contain_warning(msg).on_line(2).in_column(11)
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

      it 'should not modify the manifest' do
        expect(manifest).to eq(code)
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

      it 'should only detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the problem' do
        expect(problems).to contain_fixed(msg).on_line(2).in_column(11)
      end

      it 'should quote the case statement' do
        expect(manifest).to eq(
          <<-EOS
        $rootgroup = $osfamily ? {
          'solaris'            => 'wheel',
          /(Darwin|FreeBSD)/ => 'wheel',
          default            => 'root',
        }
          EOS
        )
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

      it 'should only detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the problem' do
        expect(problems).to contain_fixed(msg).on_line(2).in_column(11)
      end

      it 'should quote the case statement' do
        expect(manifest).to eq(
          <<-EOS
        $rootgroup = $osfamily ? {
          'Solaris'            => 'wheel',
          /(Darwin|FreeBSD)/ => 'wheel',
          default            => 'root',
        }
          EOS
        )
      end
    end

    context 'hashes in case' do
      let(:code) do
        <<-EOS
        $postfix_configuration = $configuration ? {
          'relay'     => {
            relayhost => '[example.com]:587',
            satellite => true,
          },
          'smarthost' => {
            smtp_listen       => 'all',
            master_submission => 'submission inet n - - - - smtpd -o smtpd_tls_security_level=encrypt',
            mta               => true,
            relayhost         => 'direct',
          },
        }
        EOS
      end

      it 'should not detect any problems' do
        expect(problems).to have(0).problems
      end
    end
  end
end
