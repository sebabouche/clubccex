class Clubccex::Paperdragon::Attachment < Paperdragon::Attachment
  def build_uid(style, file)
    "#{Time.now.strftime '%Y/%m/%d'}/#{SecureRandom.uuid}/#{style}-#{Dragonfly::TempObject.new(file).name}"
  end
end
