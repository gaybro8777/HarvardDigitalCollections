# frozen_string_literal: true
module Harvard::LibraryCloud

  class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

    self.default_processor_chain += [:add_search_field_to_query]
    self.default_processor_chain += [:add_range_field_to_query]
	self.default_processor_chain += [:add_setspec_field_to_query]

    def add_search_field_to_query(solr_parameters)
      solr_parameters[:search_field] = blacklight_config.search_fields[blacklight_params[:search_field]].key if blacklight_config.search_fields[blacklight_params[:search_field]]
    end

    def add_range_field_to_query(solr_parameters)
      if !@blacklight_params[:range].nil?
        solr_parameters[:range] = @blacklight_params[:range]
      end
    end
	
    def add_setspec_field_to_query(solr_parameters)
	  if !@blacklight_params[:setSpec].nil?
        solr_parameters[:setSpec] = @blacklight_params[:setSpec]
      end
    end

  end
end
