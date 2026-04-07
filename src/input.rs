use bevy::prelude::*;

#[derive(Default)]
pub struct InputPlugin;

impl Plugin for InputPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Update, keyboard_input);
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
enum NavigationInput {
    Left,
    Right,
    Up,
    Down,
    Enter,
    Back,
}

fn keyboard_input(keyboard_input: Res<ButtonInput<KeyCode>>) {
    let map = [
        (&[KeyCode::ArrowLeft, KeyCode::KeyA], NavigationInput::Left),
        (&[KeyCode::ArrowRight, KeyCode::KeyD], NavigationInput::Right),
        (&[KeyCode::ArrowUp, KeyCode::KeyW], NavigationInput::Up),
        (&[KeyCode::ArrowDown, KeyCode::KeyS], NavigationInput::Down),
        (&[KeyCode::Space, KeyCode::Enter], NavigationInput::Enter),
        (&[KeyCode::Backspace, KeyCode::Escape], NavigationInput::Back),
    ];

    for (keys, nav_input) in map {
        if keys.iter().any(|key| keyboard_input.just_pressed(*key)) {
            info!("move {:?}", nav_input);
        }
    }
}
