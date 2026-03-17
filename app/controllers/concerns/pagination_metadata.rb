module PaginationMetadata
  extend ActiveSupport::Concern

  def pagination_meta(scoped_collection)
    {
      current_page: scoped_collection.current_page,
      next_page: scoped_collection.next_page,
      prev_page: scoped_collection.prev_page,
      total_pages: scoped_collection.total_pages,
      total_count: scoped_collection.total_count
    }
  end
end
