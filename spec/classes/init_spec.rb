require 'spec_helper'
describe 'postfix' do
  context 'with default values for all parameters' do
    it { should contain_class('postfix') }
  end
end
