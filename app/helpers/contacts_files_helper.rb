module ContactsFilesHelper
  def status_label_name(status)
    case status
    when 'failed' then 'danger'
    when 'running' then 'warning'
    when 'finished' then 'success'
    end
  end

  def parse_json_data(object, method)
    data = object.send(method)
    result = data.is_a?(String) ? JSON.parse(data.tr('=>', ': ')) : data
    redordable_class = object.recordable_type&.constantize
    fields = redordable_class&.try(:columns)&.map { |x| { name: x.name, type: x.type } }
    boolean = fields&.select { |x| x[:type].eql?(:boolean) }&.map { |x| x[:name] }
    hash = result&.map { |k, v| [k, boolean&.include?(k) ? v.present? : v] }.to_h
    hash.with_indifferent_access.to_dot
  rescue JSON::ParserError
    without_braces = data[1..-2]
    array_separated = without_braces&.remove('"', "'")&.split(',')
    return unless array_separated

    hash = Hash[array_separated&.map { |x| x.strip.split(':').map(&:strip) }]
    hash.with_indifferent_access.to_dot
  end

  def action_badge(inventory_file_row)
    actions = {
      creating: { color: 'success', name: 'Creación' },
      updating: { color: 'warning', name: 'Actualización' },
      deleting: { color: 'danger', name: 'Eliminar' }
    }
    action = actions[inventory_file_row.action.to_sym]
    badge(action) if action.present?
  end

  def status_badge(inventory_file_row)
    statuses = {
      succeeded: { color: 'success', name: 'Exitosa' },
      failed: { color: 'danger', name: 'Fallida' }
    }
    status = statuses[inventory_file_row.status.to_sym]
    badge(status) if status.present?
  end

  def badge(object)
    content_tag(:span, class: "badge badge-pill badge-#{object[:color]}") do
      object[:name]
    end
  end
end
