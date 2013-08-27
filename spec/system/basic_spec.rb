require 'spec_helper_system'

describe 'testing module installation:' do

  pp = <<-EOS
    class { 'hubot': enable_epel => true, }
  EOS

  # Using puppet_apply as a subject
  context puppet_apply(pp) do
    its(:stderr)    { should be_empty }
    its(:exit_code) { should_not == 1 }
  end

end

describe 'testing redis brain setup' do

  it 'should verify that redis is all happy' do
    pending 'TODO: write this test'
  end

end

describe 'testing hubot itself:' do

  it 'i should implement some behavior test here' do
    pending 'TODO: write this test'
  end

end