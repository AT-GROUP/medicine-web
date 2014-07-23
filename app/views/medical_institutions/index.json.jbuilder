json.array!(@medical_institutions) do |medical_institution|
  json.extract! medical_institution, :id, :name, :region, :x_coord, :y_coord
  json.url medical_institution_url(medical_institution, format: :json)
end
