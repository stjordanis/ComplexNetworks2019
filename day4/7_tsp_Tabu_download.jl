using Pkg
Pkg.activate(".")


filenames = (nodelocs="walmart_node_locations.txt",routes="walmart_routes.txt",
             distkm="distkm.txt")

url = "https://s3szufel.s3.eu-central-1.amazonaws.com/ComplexNetworks2019/"

using CodecZlib

for fname in filenames
    fnamegz = fname * ".gz"
    isfile(fname) && continue
    @info "Processing $fname"
    if !isfile("$fname.gz")
        @info "Downloading $fnamegz"
        download(url*fnamegz, fnamegz)
    end
    open(fname, "w") do io_out
        open(fnamegz) do io_in
            data = read(GzipDecompressorStream(io_in))
            write(io_out, data)
        end
    end
end
@info "Done!"
