# jadia.dev | Th3Karkota.github.io

I'm using **Hyde** theme by [Mark Otto](https://github.com/mdo) as base and modified different configurations to suit my needs.

## Deploy
There is a Dockerfile to run this site on your local machine
```bash
git clone https://github.com/th3karkota/th3karkota.github.io.git

cd th3karkota.github.io

docker build -t="jekyll:jadia.dev" .

docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -p 4000:4000 -it jekyll:jadia.dev
```
You can now access the site by visiting: `http://localhost:4000`

## License

Open sourced under the [MIT license](LICENSE.md).

<3
