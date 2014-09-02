module Imageable

  def image
    # if !read_attribute(:image).nil? && !read_attribute(:image).empty?
    #   folder_path = File.join(Rails.root, 'app', 'assets', 'images', image_type)
    #   extension = File.extname(File.join(folder_path, read_attribute(:image)))
    #   file = File.join(folder_path, read_attribute(:image))
    #   if File.exists?(file)
    #     File.rename(file, File.join(folder_path, "#{image_availability}_#{id}#{extension}"))
    #   end
    #   update_attributes(extension: extension, image: nil)
    # end
    File.join(image_type, "#{image_availability}_#{id}#{self.extension}")
  end

  def delete_image
    file = File.join(Rails.root, 'app', 'assets', 'images', self.image)
    File.delete(file) if File.exists?(file)
    update_attributes(extension: nil)
  end

  def set_image(uploaded_file)
    return false if !uploaded_file
    delete_image
    file = File.open(File.join(Rails.root, 'app', 'assets', 'images', image_type, "#{image_availability}_#{id}#{File.extname(uploaded_file.original_filename)}"), "w:ASCII-8BIT")
    file.write(uploaded_file.read)
    file.close
    update_attributes(extension: File.extname(uploaded_file.original_filename))
  end

  def image_availability
    raise NotImplementedError
  end

  def image_type
    raise NotImplementedError
  end

end