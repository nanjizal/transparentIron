#version 450

in vec4 pos;
in vec4 col;
uniform mat4 WVP;

out vec4 fragmentColor;
void main() {
    fragmentColor = vec4( col );
    gl_Position =  WVP * vec4(pos.xyz, 1.0);
}