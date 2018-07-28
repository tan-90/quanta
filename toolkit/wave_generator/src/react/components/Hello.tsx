import * as React from 'react';
import {test} from '../styles/Styles.css'

export class Hello extends React.Component<{}, {}>
{
    render()
    {
        return (
            <h1 className={test}>
                Hello from TypeScript and React!
            </h1>
        );
    }
}
