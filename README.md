# Limited Color
<img src="https://github.com/JonqsGames/limited-color/assets/6182189/09de0a9c-8cdc-4e5a-8489-82001a02675d" width="450">
<img src="https://github.com/JonqsGames/limited-color/assets/6182189/465157b2-2d8b-4f62-a98a-cf073e1f6a95" width="450">

A plugin to create 3D project with a limited color palette

## Disclaimer

This is a really early version, i'm gonna use it for the upcoming 1-Bit jam and wanted to share. If it's fun to work with i may update and clean to make a better user experience.

## How it works

Create a custom 'MeshInstance3D' node with special material that have a color (index in palette).

Color is stored in red channel, light applied to green and unique index in blue.

A post process quad then seak the color into the palette and apply shadow using dithering pattern provided.

## The plugin

A 'LimitedColor' dock is availabe to change palette and bayer matrix and save it.

![image](https://github.com/JonqsGames/limited-color/assets/6182189/8b13c6c4-95e6-42a3-bc52-5dfa9325d9c3)

## License

Limited Color is distributed under the MIT license. See [LICENSE.txt](LICENSE.txt) for more details.

Food assets in example are from [Kenney.nl](https://kenney.nl/assets/food-kit)
