require_relative '../app'
describe App do

    it 'Visit index page' do
        except 10.to be(10)
    end

    it "should have a file named app.rb" do
        excpet(File.exists('../app.rb')).to be(true)
    end

end
