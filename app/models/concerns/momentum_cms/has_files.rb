module MomentumCms
  module HasFiles
    extend ActiveSupport::Concern

    included do

      # == Constants ============================================================

      # == Attributes ===========================================================

      # == AR Extensions ========================================================

      # == Relationships ========================================================

      has_many :files,
               class_name: 'MomentumCms::File',
               as: :attachable,
               dependent: :destroy

      accepts_nested_attributes_for :files,
                                    reject_if: lambda { |t| t['file'].nil? },
                                    allow_destroy: true

      # == Validations ==========================================================

      # == Scopes ===============================================================

      # == Callbacks ============================================================

      before_save :remove_empty_files

      # == Class Methods ========================================================

      # == Instance Methods =====================================================
      def find_all_files
        self.files.order('tag')
      end

      def find_files_by_tag(tag, method = :first)
        files = self.files.where(tag: tag)
        if method
          files.send(method)
        else
          files
        end
      end

      def method_missing(sym, *args, &block)
        method_name = sym.to_s
        if method_name.start_with?('files_')
          method = method_name.split('files_').last
          self.find_files_by_tag(method).try(:files)
        elsif method_name.start_with?('multiple_files_')
          method = method_name.split('multiple_files_').last
          self.find_files_by_tag(method, :to_a)
        else
          super
        end
      end

      def build_files_if_not_exist_by_tag(tag, options = {})
        multiple = options.fetch(:multiple, false)
        require_image = options.fetch(:require_image, false)
        tag = tag.gsub(/[^0-9a-zA-Z]/i, '_')
        initialized = self.files.select { |files| files.tag == tag }
        persisted = self.find_files_by_tag(tag)
        if initialized.blank? && persisted.blank? || multiple
          self.files.build(
            identifier: "#{self.identifier}-#{tag}",
            tag: tag,
            multiple: multiple,
            require_image: require_image,          
            attachable: self,
            site: options.fetch(:site, nil)
          )
        end
      end

      protected
      def remove_empty_files
        self.files.each do |file|
          self.files.delete(file) if !file.file?
        end
      end
    end

    module ClassMethods
    end
  end
end