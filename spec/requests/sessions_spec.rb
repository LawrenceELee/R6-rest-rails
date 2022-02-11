require 'swagger_helper'

describe 'sessions API' do

  #Creates swagger for documentaion for login
  path '/users/sign_in' do

    post 'Creates a session' do
      let(:user1) { FactoryBot.create(:user) }
      tags 'sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: { user: { properties: {
          email: { type: :string },
          password: { type: :string}
        }}},
        required: [ 'email', 'password' ]
      } # close parameter

      # respond with success (201) if user has both email and password
      response '201', 'session jwt token created' do
        let(:user) do
          { user: {
          email: user1.email,
          password: user1.password
          }}
        end
        run_test!
      end #end response

      # respond with failure (401) if blank password
      response '401', 'Unauthorized' do
        let(:user) do
          { user: {
          email: user1.email,
          password: ""
          } }
        end
        run_test!
      end #end response

    end   #end post

  end #end path

  #Swagger documentation for logout.
  path '/users/sign_out' do

    # the delete operation of CRUD
    delete 'Destroy JWT token' do
      let(:user) { FactoryBot.create(:user) }
      # For logout it is necessary that the user be authenticated. So we have to create a user, and then a token associated with that user. That is done with the lines
      let (:auth_header) {"Bearer "+Warden::JWTAuth::UserEncoder.new.call(user, :user,nil)[0]}
      tags 'sessions'
      consumes 'application/json'
      produces 'application/json'
      # To have access to the JWTAuth helper that creates the token, we have to require the jwt test helpers, as per the second line in this file. We also have to tell swagger that authentication is needed for this API. That is done with the line:
      security [Bearer: {}]

      #This includes a valid auth token header
      response '200', 'blacklist token' do
        let(:"Authorization") {auth_header}
        run_test!
      end

      #This does not include anything in the header so it fails
      response '401', 'no token to blacklist' do
        let(:"Authorization") {}
        run_test!
      end

    end #end delete

  end #end path

end #end describe
