# # encoding: utf-8

# Inspec test for recipe jenkins-server::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end

describe package('oracle-java8-installer') do
	it {should be_installed}
end

describe package('oracle-java8-set-default') do
	it {should be_installed}
end


 describe package("java-1.8.0-oracle") do
      it { should be_installed } 
  end

# describe package 'java' do
# 	it {should be_installed}
# 	its('version'){ should match /1\.8\../ }
# end


describe package('jenkins') do
	it {should be_installed} 
end


describe port(8080) do
	it {should be_listening}
	# its('addresses'){should include '0.0.0.0' }
end

# describe elasticsearch do
#   its('java.version') { should cmp '1.8.0' }
# end


describe package('apache2') do
	it {should be_installed}
	its('version') {should match /2\.4\./}
end



