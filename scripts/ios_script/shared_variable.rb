# shared_variable.rb

module SharedVariable
  @app_name = nil
  @company_name = nil
  @company_code = nil
  @scheme_name = nil
  @url_extension = nil
  @bundle_identifier = nil

  def self.update_variables(app_name, company_name, company_code, scheme_name, url_extension, bundle_identifier)
    @app_name = app_name
    @company_name = company_name
    @company_code = company_code
    @scheme_name = scheme_name
    @url_extension = url_extension
    @bundle_identifier = bundle_identifier
  end

  def self.app_name
    @app_name
  end

  def self.company_name
    @company_name
  end

  def self.company_code
    @company_code
  end

  def self.scheme_name
    @scheme_name
  end

  def self.url_extension
    @url_extension
  end

  def self.bundle_identifier
    @bundle_identifier
  end
end
