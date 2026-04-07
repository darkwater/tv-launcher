use bevy::prelude::*;
use bevy_egui::prelude::*;
#[cfg(debug_assertions)]
use bevy_inspector_egui::quick::WorldInspectorPlugin;

mod debug;
mod input;

fn main() {
    let mut app = App::new();
    app.add_plugins((DefaultPlugins, input::InputPlugin))
        .add_systems(Startup, setup);

    #[cfg(debug_assertions)]
    app.add_plugins((debug::DebugPlugin, EguiPlugin::default(), WorldInspectorPlugin::new()));

    app.run();
}

fn setup(mut commands: Commands) {
    commands.spawn((
        Camera2d::default(),
        Camera {
            clear_color: ClearColorConfig::Custom(Color::BLACK),
            ..Default::default()
        },
        // Transform::from_xyz(-5.0, 0.0, 0.0).looking_at(Vec3::ZERO, Vec3::Y),
    ));

    commands.spawn((Text2d::new("Library"), Transform::from_xyz(0.0, -200.0, 0.0), TextLayout {
        justify: Justify::Left,
        linebreak: LineBreak::WordOrCharacter,
    }));
}
