require 'net/http'
require 'uri'
require 'json'

class SearchController < ApplicationController
  @@sparql_uri = URI.parse(CONFIG['sparql_server'] + 'select?output=json')

  def fields
    taxonomy = params[:taxonomy]

    query = 'PREFIX leaves: <' + CONFIG['leaves_prefix'] + '#>
             PREFIX skos: <' + CONFIG['skos_prefix'] + '#>
             SELECT DISTINCT ?s ("Label" AS ?p) ?o
             WHERE {
               ?t leaves:MemberOfCompositionTaxonomy <' + taxonomy + '> ;
                  ?s ?v .
               ?s skos:prefLabel ?o
             }'

    render json: get_results(query)
  end

  def taxonomies
    query = 'PREFIX leaves: <' + CONFIG['leaves_prefix'] + '#>
             PREFIX skos: <' + CONFIG['skos_prefix'] + '#>
              SELECT ?s ("Label" AS ?p) ?o WHERE {
               ?s rdf:type leaves:Taxonomy ;
                  skos:prefLabel ?o
             }'

    render json: get_results(query)
  end

  def fetch
    render json: params[:fields]
  end

  def get_results(query)
    response = Net::HTTP.post_form(@@sparql_uri, 'query' => query)
    data = JSON.parse(response.body)['results']['bindings']
    parse_results(data)
  end

  def parse_results(json_triples)
    results = {}

    json_triples.each do |triple|
      results[triple['s']['value']] = results[triple['s']['value']] || {}
      results[triple['s']['value']][triple['p']['value']] = results[triple['s']['value']][triple['p']['value']] || []
      results[triple['s']['value']][triple['p']['value']] += [triple['o']['value']]
    end

    results
  end
end
