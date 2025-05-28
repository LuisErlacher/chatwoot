# fix: Added authentication to FireCrawl API, remove unused RobinAI references (#10737)

#- Fixed Firecrawl webhook payloads to ensure proper data handling and
# delivery.
#- Removed unused Robin AI code to improve codebase cleanliness and
# maintainability.
#- Implement authentication for the Firecrawl endpoint to improve
# security. A key is generated to secure the webhook URLs from FireCrawl.

#---------
module Captain::FirecrawlHelper
  def generate_firecrawl_token(assistant_id, account_id)
    api_key = InstallationConfig.find_by(name: 'CAPTAIN_FIRECRAWL_API_KEY')&.value
    return nil unless api_key

    token_base = "#{api_key[-4..]}#{assistant_id}#{account_id}"
    Digest::SHA256.hexdigest(token_base)
  end
end
