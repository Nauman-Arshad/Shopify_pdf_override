class Resume < ApplicationRecord
  has_one_attached :file
  before_commit :read_pdf

  
  def read_pdf
    # byebug

  end
end
