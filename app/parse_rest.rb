class ParseREST

  HEADER = {"X-Parse-Application-Id" => 'DK4ENWAsFwyXWJWb3SNpw2p1KeGURVhr2JOz2mpV',
              "X-Parse-REST-API-Key" => 'I17mFBJD2GHJREN9Ap3Ki9hiHt4dmN8TzfGHs74m',
                      'Content-Type' => 'application/json'}
  REST_URL = "https://api.parse.com/1/classes/Example"

  def self.save(info, &block)
    content = BW::JSON.generate(info)
    options = {:headers => HEADER,:payload => content}
    url = REST_URL
    BW::HTTP.post(url, options) do |response|
      block.call(response.body.to_str)
    end

  end

  def self.list(&block)
    options = {:headers => HEADER}
    url = REST_URL
    BW::HTTP.get(url, options) do |response|
      result = BW::JSON.parse(response.body.to_str)
      block.call(result["results"])
    end

  end

end