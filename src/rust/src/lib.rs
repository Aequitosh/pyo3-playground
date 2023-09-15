use pyo3::prelude::*;

#[pyfunction]
fn hello_world() -> PyResult<String> {
    Ok(String::from("Hello World!"))
}

#[pymodule]
fn _lib(_py: Python<'_>, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(hello_world, m)?)?;

    Ok(())
}
