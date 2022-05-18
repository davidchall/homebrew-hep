# frozen_string_literal: true

def download_pdfs(dest, pdfs)
  require "utils"

  ohai "Downloading PDFs..."
  Array(pdfs).each { |pdf| quiet_system "lhapdf", "--pdfdir=#{dest}", "install", pdf }
  ENV["LHAPDF_DATA_PATH"] = dest
end
